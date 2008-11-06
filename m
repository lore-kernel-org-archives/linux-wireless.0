Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:30447 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYKFVrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 16:47:41 -0500
Received: by yw-out-2324.google.com with SMTP id 9so345821ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 13:47:40 -0800 (PST)
Message-ID: <43e72e890811061347m3bd7ece8sad85c3d808abf49c@mail.gmail.com> (sfid-20081106_224749_663786_D22CA973)
Date: Thu, 6 Nov 2008 13:47:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Benoit PAPILLAULT" <benoit.papillault@free.fr>
Subject: Re: [ath9k-devel] [PATCH] ath9k : Display MAC/BB and RF version at startup (v2)
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <49136119.6060407@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <490F63B6.8080600@free.fr> <878ws0ar2u.fsf@nokia.com>
	 <20081105030223.GD16413@tesla> <49119C3D.1060406@free.fr>
	 <49136119.6060407@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 1:26 PM, Benoit PAPILLAULT
<benoit.papillault@free.fr> wrote:
> This patch decodes the MAC/BB version (for instance: AR5416) and the RF
> part version (for instance: AR5133). It has been tested on AR5416/AR5133
> which is a 2.4/5GHz 11n device. It also makes the differences between
> AR5416 (PCI) and AR5418 (PCI Express). Both are named AR5416 in
> the register definitions.
>
> Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>

thanks, I'm going to test it on our later hardware, but patch fails
with git am (and therefore with patch itself):

mcgrof@mosca ~/wireless-testing (git::11dv3)$ patch -p1 <
/home/mcgrof/name-ath9k.patch
patching file drivers/net/wireless/ath9k/hw.c
patching file drivers/net/wireless/ath9k/main.c
patch: **** malformed patch at line 105: pci_device_id *id)

  Luis
