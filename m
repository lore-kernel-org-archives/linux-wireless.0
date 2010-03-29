Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:48350 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0C2Xna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:43:30 -0400
Received: by gxk9 with SMTP id 9so1983337gxk.8
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 16:43:30 -0700 (PDT)
Message-ID: <4BB13B1C.2010608@lwfinger.net>
Date: Mon, 29 Mar 2010 18:43:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [BUG] No SPROM available!
References: <4BB0FD96.5020402@lwfinger.net> <4BB10110.9090202@googlemail.com> <20100329194745.GH4984@tuxdriver.com> <4BB10A0F.1030608@lwfinger.net> <20100329204822.GL4984@tuxdriver.com> <20100329205558.GM4984@tuxdriver.com> <4BB11B8E.1020506@lwfinger.net> <4BB12148.7080309@googlemail.com> <4BB13147.9020002@lwfinger.net> <4BB135EC.1070502@googlemail.com>
In-Reply-To: <4BB135EC.1070502@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2010 06:21 PM, René Bolldorf wrote:
> 
> ssb: chip_id 0x4312, status 0x12
> ssb: cc rev 0x16, cc capab 0x18600000
> 
> And my system completely hangs after this... :(

Nothing in that patch should make it hang. Has that happened before?

Larry

