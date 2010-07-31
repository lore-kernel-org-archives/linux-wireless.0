Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:46499 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab0GaOQV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 10:16:21 -0400
From: Thomas Klute <thomas2.klute@uni-dortmund.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, dcbw@redhat.com,
	libertas-dev@lists.infradead.org,
	Thomas Klute <thomas2.klute@uni-dortmund.de>
Subject: [PATCH 1/2] libertas_tf: if_usb.c: Whitespace cleanup
Date: Sat, 31 Jul 2010 12:01:44 +0200
Message-Id: <1280570505-6791-1-git-send-email-thomas2.klute@uni-dortmund.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Thomas Klute <thomas2.klute@uni-dortmund.de>
---
 drivers/net/wireless/libertas_tf/if_usb.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas_tf/if_usb.c b/drivers/net/wireless/libertas_tf/if_usb.c
index b172f5d..f93260b 100644
--- a/drivers/net/wireless/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/libertas_tf/if_usb.c
@@ -54,7 +54,7 @@ static int if_usb_reset_device(struct if_usb_card *cardp);
 /**
  *  if_usb_wrike_bulk_callback -  call back to handle URB status
  *
- *  @param urb 		pointer to urb structure
+ *  @param urb		pointer to urb structure
  */
 static void if_usb_write_bulk_callback(struct urb *urb)
 {
@@ -187,7 +187,7 @@ static int if_usb_probe(struct usb_interface *intf,
 
 			lbtf_deb_usbd(&udev->dev, "out_endpoint = %d\n", cardp->ep_out);
 			lbtf_deb_usbd(&udev->dev, "Bulk out size is %d\n",
-			              cardp->ep_out_size);
+				cardp->ep_out_size);
 		}
 	}
 	if (!cardp->ep_out_size || !cardp->ep_in_size) {
@@ -367,7 +367,7 @@ EXPORT_SYMBOL_GPL(if_usb_reset_device);
 /**
  *  usb_tx_block - transfer data to the device
  *
- *  @priv 	pointer to struct lbtf_private
+ *  @priv	pointer to struct lbtf_private
  *  @payload	pointer to payload data
  *  @nb		data length
  *  @data	non-zero for data, zero for commands
@@ -689,7 +689,7 @@ static void if_usb_receive(struct urb *urb)
 	}
 	default:
 		lbtf_deb_usbd(&cardp->udev->dev,
-		         "libertastf: unknown command type 0x%X\n", recvtype);
+			"libertastf: unknown command type 0x%X\n", recvtype);
 		kfree_skb(skb);
 		break;
 	}
-- 
1.7.1

