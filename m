Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:59081 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbZKWSNB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 13:13:01 -0500
Received: by mail-ew0-f219.google.com with SMTP id 19so2118321ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 23 Nov 2009 10:13:07 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 3/6] rt2x00: Clean up use of rt2x00_intf_is_pci.
Date: Mon, 23 Nov 2009 19:13:05 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
References: <1258960565-26736-1-git-send-email-gwingerde@gmail.com> <1258960565-26736-3-git-send-email-gwingerde@gmail.com> <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1258960565-26736-4-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200911231913.05203.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 23 November 2009, Gertjan van Wingerde wrote:
> RT chipsets are unique across both PCI and USB busses, and don't overlap.
> Therefore there is no need to test for bus type when only checking for
> chipset type. Remove the redundant checks.
> 
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
