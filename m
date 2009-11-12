Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53931 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZKLTez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:34:55 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so2613056bwz.21
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 11:35:00 -0800 (PST)
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2] rt2x00: Initialize rf302x RF values properly
 =?iso-8859-1?q?for=09rt2800pci=2E?=
Date: Thu, 12 Nov 2009 20:32:53 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@iki.fi>, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
References: <1257889360-388-1-git-send-email-gwingerde@gmail.com> <20091111142823.GC4392@tuxdriver.com> <4AFB1BB1.7050106@gmail.com>
In-Reply-To: <4AFB1BB1.7050106@gmail.com>
MIME-Version: 1.0
Message-Id: <200911122032.54020.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 11 November 2009 21:16:49 Gertjan van Wingerde wrote:
> On 11/11/09 15:28, John W. Linville wrote:
> > On Wed, Nov 11, 2009 at 08:33:15AM +0200, Kalle Valo wrote:
> >> Gertjan van Wingerde <gwingerde@gmail.com> writes:
> >>
> >>> Ensure RF302x and RF2020 chipsets are handled properly in rt2800lib for the rt3090 chipset.
> >>>
> >>> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
> >>
> >> Please line wrap commit logs. 72 characters or so per line is a good
> >> limit.
> > 
> > Yes, ACK.
> > 
> 
> I'm terribly sorry about that. I still have to get used to my new big wide-screen monitor, and the windows of wider than 80 characters :-(
> 
> I'll keep it in mind for my next patch submissions.

I've been fixing this in rt2800 tree for all patches.. ;)

-- 
Bartlomiej Zolnierkiewicz
