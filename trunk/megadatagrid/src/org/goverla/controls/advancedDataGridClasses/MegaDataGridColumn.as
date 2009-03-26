package org.goverla.controls.advancedDataGridClasses
{
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.mx_internal;
	
	import org.goverla.renderers.CloseableClassFactory;

	use namespace mx_internal;

	public class MegaDataGridColumn extends AdvancedDataGridColumn
	{
		public function get group() : MegaDataGridColumnGroup
		{
			return _group;
		}

		public function set group(value : MegaDataGridColumnGroup) : void
		{
			if (_group != value)
			{
				_group = value;
				invalidateOwner();
			}
		}

		[Inspectable(category="General", enumeration = "true,false", defaultValue = "false")]
		public function get hideable() : Boolean
		{
			return _hideable;
		}

		public function set hideable(value : Boolean) : void
		{
			_hideable = value;

			if (value)
			{
				invalidateOwner();
			}
			else
			{
				visible = true;
			}
		}

		[Inspectable(category="General", enumeration = "true,false", defaultValue = "false")]
		public function get closeable() : Boolean
		{
			return _closeable;
		}

		public function set closeable(value : Boolean) : void
		{
			if (_closeable != value)
			{
				_closeable = value;

				if (value)
				{
					if (headerRenderer is ClassFactory)
					{
						headerRenderer = new CloseableClassFactory(ClassFactory(headerRenderer).generator)
					}
					else if (headerRenderer == null)
					{
						headerRenderer = new CloseableClassFactory(AdvancedDataGridHeaderRenderer);
					}
				}
			}
		}
		
		[Bindable]
		public override function get width() : Number
		{
			return fixedWidth ? _width : super.width;
		}

		public override function set width(value : Number) : void
		{
			_width = value;
			super.width = value;

			if (fixedWidth)
			{
				_oldMinWidthValue = super.minWidth;
				super.minWidth = _width;
			}
		}

		public override function get visible() : Boolean
		{
			return (hideable && group != null && !group.expanded) ? false : super.visible;
		}

		[Bindable]
		public function get fixedWidth() : Boolean
		{
			return _fixedWidth;
		}

		public function set fixedWidth(value : Boolean) : void
		{
			if (value != _fixedWidth)
			{
				_fixedWidth = value;

				if (_fixedWidth)
				{
					this.width = super.width;
					_oldResizableValue = super.resizable;
					super.resizable = false;
				}
				else
				{
					super.resizable = _oldResizableValue;
					super.minWidth = _oldMinWidthValue;
				}
			}
		}

		public override function set headerRenderer(value : IFactory) : void
		{
			if (closeable && !(value is CloseableClassFactory) &&
				value != null &&
				value is ClassFactory)
			{
				super.headerRenderer = new CloseableClassFactory(ClassFactory(value).generator)
			}
			else
			{
				super.headerRenderer = value;
			}
		}

		public function get x() : Number
		{
			var result : Number = 0;

			if (owner != null)
			{
				for each (var column : Object in owner.columns)
				{
					var groupVisible : Boolean = column.group != null ? column.group.visible : true;

					if (column == this)
					{
						break;
					}
					else if (column.visible != false && groupVisible)
					{
						result += column.width;
					}
				}
			}
			return result;
		}

		public function MegaDataGridColumn(columnName : String = null)
		{
			super(columnName);
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

		mx_internal override function setWidth(value : Number) : void
		{
			super.setWidth(isNaN(value) ? 0 : value);
		}

		private var _group : MegaDataGridColumnGroup;

		private var _hideable : Boolean = false;

		private var _closeable : Boolean = false;

		// default width for fixed column
		private var _width : Number = 30;
		
		private var _fixedWidth : Boolean = false;

		private var _oldResizableValue : Boolean = true;

		private var _oldMinWidthValue : Number = 0;
	}
}