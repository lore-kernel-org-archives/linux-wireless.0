Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53068 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbZKHNDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2009 08:03:10 -0500
Received: by ewy3 with SMTP id 3so2355759ewy.37
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2009 05:03:14 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH] rt2x00: Mark rt2800pci as broken.
Date: Sun, 8 Nov 2009 14:02:25 +0100
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1257679734-25160-1-git-send-email-gwingerde@gmail.com> <200911081338.34697.bzolnier@gmail.com> <4AF6BE7D.8060301@gmail.com>
In-Reply-To: <4AF6BE7D.8060301@gmail.com>
MIME-Version: 1.0
Message-Id: <200911081402.25916.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 November 2009 13:50:05 Gertjan van Wingerde wrote:
> On 11/08/09 13:38, Bartlomiej Zolnierkiewicz wrote:
> > 
> > [ This is against rt2800 tree right?  Cause I don't see any of my patches
> >   in public rt2x00 tree yet. ]
> > 
> 
> Actually, it is against wireless-testing.

Interesting. :)

John, you may want to replace what you have with rt2800-v2.1 branch of
misc.git tree (more ACKs from Ivo and order is optimized a bit based on
feedback from Julian).

-- 
Bartlomiej Zolnierkiewicz
