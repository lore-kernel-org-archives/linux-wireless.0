Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f170.google.com ([74.125.82.170]:43659 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaAWJEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:04:39 -0500
Received: by mail-we0-f170.google.com with SMTP id u57so880426wes.29
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jan 2014 01:04:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>
References: <52DF947E.40800@gmail.com> <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
 <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
 <52E0BA40.7090203@gmail.com> <CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>
 <52E0D7D5.6060504@gmail.com> <CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 23 Jan 2014 14:34:18 +0530
Message-ID: <CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com> (sfid-20140123_100446_139118_C5370E2A)
Subject: Re: 802.11a is supported in AP mode or not?
To: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
Cc: zhuyj <zyjzyj2000@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 2:29 PM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> Is there any method to set the 5GHz channels be able?
>
> Please show me the command...:)
No it doesn't work that way, based on regulatory info and HW capability
the framework will decide that.

Lets give it a try with latest hostapd from git and see.
