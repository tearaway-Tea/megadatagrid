package org.goverla.controls.advancedDataGridClasses
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumnGroup;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	
	import org.goverla.renderers.CloseableClassFactory;
	import org.goverla.renderers.ExpandableGroupHeaderRenderer;

	use namespace mx_internal;

	public class MegaDataGridColumnGroup extends AdvancedDataGridColumnGroup 
	{
		[Inspectable(category="General", enumeration = "true,false", defaultValue = "false")]
		public function get expandable() : Boolean
		{
			return _expandable;
		}

		public function set expandable(value : Boolean) : void
		{
			if (_expandable != value)
			{
				_expandable = value;

				if (!value)
				{
					expanded = true;
				}

				invalidateOwner();
				updateHeaderRenderer();
			}
		}

		[Inspectable(category="General", enumeration = "true,false", defaultValue = "true")]
		public function get expanded() : Boolean
		{
			return _expanded;
		}

		public function set expanded(value : Boolean) : void
		{
			_expanded = value;
			invalidateOwner();
		}

		public function get closeable() : Boolean
		{
			return _closeable;
		}

		public function set closeable(value : Boolean) : void
		{
			if (_closeable != value)
			{
				_closeable = value;
				updateHeaderRenderer();
			}
		}

		public override function set headerRenderer(value : IFactory) : void
		{
			super.headerRenderer = getHeaderRenderer(value);
		}

		public function MegaDataGridColumnGroup(columnName : String = null)
		{
			super(columnName);
		}

		public function addColumn(column : Object) : void
		{
			if (!containsColumn(column))
			{
				addColumnAt(column);
			}
		}

		public function addColumnAt(column : Object, startFrom : int = -1) : void
		{
			if (!containsColumn(column))
			{
				if (startFrom == -1)
				{
					startFrom = children.length;
				}

				column.group = this;
				children.splice(startFrom, 0, column);
			}
		}

		public function removeColumn(column : Object) : void
		{
			if (containsColumn(column))
			{
				column.group = null;
				children.splice(children.indexOf(column), 1);
			}
		}

		public function containsColumn(column : Object) : Boolean
		{
			return children.indexOf(column) > -1;
		}
		
		protected function invalidateOwner() : void
		{
			if (owner != null)
			{
				owner.columnsInvalid = true;

				owner.invalidateProperties();
				owner.invalidateSize();
				owner.invalidateList();
			}
		}

		protected function updateChildrenGroup() : void
		{
			for each (var child : Object in children)
			{
				var column : MegaDataGridColumn = child as MegaDataGridColumn;

				if (column != null)
				{
					column.group = this;
				}
			}
		}

		// TODO: Create ExpandableClassFactory
		protected function getHeaderRenderer(headerRenderer : IFactory) : IFactory
		{
			var result : IFactory = headerRenderer;

			if (expandable && closeable)
			{
				result = new CloseableClassFactory(ExpandableGroupHeaderRenderer);
			}
			else if (expandable && !closeable)
			{
				result = new ClassFactory(ExpandableGroupHeaderRenderer);
			}
			else if (headerRenderer == null && closeable)
			{
				result = new CloseableClassFactory(AdvancedDataGridHeaderRenderer);
			}
			else if (headerRenderer is ClassFactory && closeable)
			{
				var generator : Class = ClassFactory(headerRenderer).generator;
				result = new CloseableClassFactory(generator);
			}

			return result;
		}

		private function updateHeaderRenderer() : void
		{
			headerRenderer = headerRenderer;
		}

		private var _expanded : Boolean = true;

		private var _expandable : Boolean = false;

		private var _closeable : Boolean = false;
	}
}