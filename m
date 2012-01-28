Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51567 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab2A1QoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 11:44:21 -0500
Message-ID: <4F2425E1.7090407@lwfinger.net> (sfid-20120128_174441_261829_97EB78A9)
Date: Sat, 28 Jan 2012 10:44:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "devendra.aaru" <devendra.aaru@gmail.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: so many if conditions in _rtl92c_store_pwrIndex_diffrate_offset.
References: <CAHdPZaMWC6_bGXXJvjbmJDz-JDF7gx8QUTd2e8iW=5+ecTPiSg@mail.gmail.com>
In-Reply-To: <CAHdPZaMWC6_bGXXJvjbmJDz-JDF7gx8QUTd2e8iW=5+ecTPiSg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2012 12:31 AM, devendra.aaru wrote:
> Hi wireless folks,
>
> in _rtl92c_store_pwrIndex_diffrate_offset (
> drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c), there are lot of
> if conditions, checking the register address.
> my understanding is that if the register address matches to a
> particular rate, we set the txpower level to a particular group. but
> it is even possible with the switch or if else if statements,
>   please correct me if i am wrong.

Of course, that routine could be recoded using either a switch or if else 
statements. Unfortunately, I have more pressing matters to attend to. You can, 
however, submit a patch to change it and send it to the linux-wireless mailing 
list. You must follow the instructions in Documentation/SubmittingPatches, and 
the patch must apply using the wireless-testing git tree.

Larry

