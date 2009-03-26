package org.goverla.renderers
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
	
	import org.goverla.controls.advancedDataGridClasses.MegaDataGridColumn;
	import org.goverla.controls.advancedDataGridClasses.MegaDataGridColumnGroup;
	import org.goverla.events.HeaderRendererEvent;

	[Style(name="expandIcon", type = "Class", inherit = "no")]

	[Style(name="collapseIcon", type = "Class", inherit = "no")]

	public class ExpandableGroupHeaderRenderer extends AdvancedDataGridHeaderRenderer
	{
		public override function set data(value : Object) : void
		{
			super.data = value;
			_dataChanged = true;
			invalidateProperties();
		}

		protected function get expandIcon() : Class
		{
			return getStyle("expandIcon");
		}

		protected function get collapseIcon() : Class
		{
			return getStyle("collapseIcon");
		}

		protected override function createChildren() : void
		{
			super.createChildren();

			if (!_image)
			{
				_image = new Image();
				_image.buttonMode = true;
				_image.visible = false;
				_image.addEventListener(MouseEvent.CLICK, onImageClick);
				_image.width = 9
				_image.height = 9;				

				addChild(_image);
			}
		}

		protected override function commitProperties() : void
		{
			super.commitProperties();

			if (_dataChanged)
			{
				_dataChanged = false;

				_image.visible = false;

				_group = data as MegaDataGridColumnGroup;

				if (_group && _group.expandable && hasVisibleFixedColumn(_group))
				{
					_image.visible = true;
					_image.source = _group.expanded ? collapseIcon : expandIcon;
				}

				invalidateDisplayList();
			}
		}

		protected override function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			if (_image.visible)
			{
				_image.move(unscaledWidth - _image.width - 2, 1);
			}
		}

		private function onImageClick(event : MouseEvent) : void
		{
			if (_group)
			{
				_group.expanded = !_group.expanded;
				_image.source = _group.expanded ? collapseIcon : expandIcon;

				var headerEvent : HeaderRendererEvent =
					new HeaderRendererEvent(HeaderRendererEvent.GROUP_HEADER_EXPANDED_CHANGE, true);
				headerEvent.data = _group;
				dispatchEvent(headerEvent);
			}
		}

		private function hasVisibleFixedColumn(group : MegaDataGridColumnGroup) : Boolean
		{
			// we should find at least 1 column what has hidable property == false
			for each (var column : Object in group.children)
			{
				if (column is MegaDataGridColumn)
				{
					return MegaDataGridColumn(column).visible && MegaDataGridColumn(column).hideable == false;
				}
				else if (column is MegaDataGridColumnGroup)
				{
					return MegaDataGridColumnGroup(column).visible && hasVisibleFixedColumn(MegaDataGridColumnGroup(column));
				}
			}
			
			return false;
		}

		private var _image : Image;

		private var _dataChanged : Boolean = false;

		private var _group : MegaDataGridColumnGroup;
	}
}