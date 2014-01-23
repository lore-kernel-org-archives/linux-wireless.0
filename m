Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:37554 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbaAWJHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 04:07:38 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: zhuyj <zyjzyj2000@gmail.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Thu, 23 Jan 2014 09:07:35 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C3931@ALA-MBB.corp.ad.wrs.com> (sfid-20140123_100800_240987_4E50EE6A)
References: <52DF947E.40800@gmail.com>
 <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
 <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
 <52E0BA40.7090203@gmail.com>
 <CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>
 <52E0D7D5.6060504@gmail.com>
 <CABPxzYLZO9RDDpVOUTjmNWqVz71S_ufVKWy9UsejfsNGbyCcow@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C38F6@ALA-MBB.corp.ad.wrs.com>,<CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>
In-Reply-To: <CABPxzYLMosYvkhTxq+8WJOwhQuxinSxQ64TeSU+3YgqcjhZa0g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By using latest hostapd, version, not works as well.

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Krishna Chaitanya [chaitanya.mgit@gmail.com]
Sent: Thursday, January 23, 2014 5:04 PM
To: Liu, Bopeng
Cc: zhuyj; Emmanuel Grumbach; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 2:29 PM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> Is there any method to set the 5GHz channels be able?
>
> Please show me the command...:)
No it doesn't work that way, based on regulatory info and HW capability
the framework will decide that.

Lets give it a try with latest hostapd from git and see.
