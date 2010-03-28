Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f222.google.com ([209.85.219.222]:49562 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab0C1QZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 12:25:08 -0400
Received: by ewy22 with SMTP id 22so1592711ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 09:25:07 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] wireless: rt2x00: rt2800usb: identify ids-chips
Date: Sun, 28 Mar 2010 17:19:57 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linville@tuxdriver.com
References: <1269784363-6077-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1269784363-6077-1-git-send-email-xose.vazquez@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201003281819.57992.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 28 March 2010, Xose Vazquez Perez wrote:
> Taken from ralink linux drivers:
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0B05,0x1784)}, /* Asus 3072 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x13D3,0x3305)}, /* AzureWave 3070*/
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x07D1,0x3C16)}, /* D-Link 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x203D,0x14A9)}, /* Encore 3070*/
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x1740,0x9707)}, /* EnGenius 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x1740,0x9708)}, /* EnGenius 3071 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x1740,0x9709)}, /* EnGenius 3072 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x04BB,0x0947)}, /* I-O DATA 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x04BB,0x0948)}, /* I-O DATA 3072 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x3822)}, /* MSI 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x3821)}, /* Ralink 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x3870)}, /* MSI 3070*/
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x3871)}, /* MSI 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x821A)}, /* Ralink 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x822A)}, /* MSI 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x870A)}, /* MSI 3070*/
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x871A)}, /* MSI 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DB0,0x899A)}, /* MSI 3070*/
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x20B8,0x8888)}, /* PARA INDUSTRIAL 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DF6,0x0048)}, /* Sitecom 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x0DF6,0x0047)}, /* Sitecom 3071 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x083A,0xA701)}, /* SMC 3070 */
> RT3070_LinuxSTA_V2.3.0.1_20100208/common/rtusb_dev_id.c:        {USB_DEVICE(0x083A,0xA702)}, /* SMC 3072 */
> 
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
