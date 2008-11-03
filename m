Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:46051 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771AbYKCQrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 11:47:22 -0500
Received: by nf-out-0910.google.com with SMTP id d3so1022651nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 08:47:20 -0800 (PST)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [GIT PATCH] rfkill fixes for 2.6.28-rc3
Date: Mon, 3 Nov 2008 17:47:16 +0100
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1225730537-2679-1-git-send-email-hmh@hmh.eng.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811031747.16326.IvDoorn@gmail.com> (sfid-20081103_174726_484642_8754E1A0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 03 November 2008, Henrique de Moraes Holschuh wrote:
> 
> John, Ivo,
> 
> This small patchset contains two fixes to issues in the suspend/resume
> handling of the rfkill class core.
> 
> It needs to go to 2.6.28.  These patches are based on 2.6.28-rc3.

Are they real regressions or normal bugfixes?

> Chances are they will *clash* with what is in wireless-testing, so I will
> send a rebased patchset for wireless-testing with these patches on the
> bottom of the stack (to make merging easier with mainline).
> 
> The patches are also needed on stable, but won't apply automatically.  I
> don't think I will bother with 2.6.26 since the suspend/resume restore of
> radio state there is not going to work well anyway, unless I backport a bit
> more stuff... but 2.6.27 deserves to get them.
> 


