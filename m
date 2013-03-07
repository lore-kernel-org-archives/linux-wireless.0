Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:49004 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab3CGRCC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 12:02:02 -0500
Message-ID: <5138C806.5010309@lwfinger.net> (sfid-20130307_180210_122346_1374853D)
Date: Thu, 07 Mar 2013 11:01:58 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Matt Chen <machen@suse.com>
CC: Joe Perches <joe@perches.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org, Jeffrey Cheung <jcheung@suse.com>,
	Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC/RFT 00/27] Updates for the rtlwifi family of drivers
References: <1361837619-2985-1-git-send-email-Larry.Finger@lwfinger.net> <1361845357.2023.7.camel@joe-AO722> <512C264A.3000104@lwfinger.net> <CALx5=V_Y2=bZWXzc9uQkmTBAECeMLbnPU0VA56Wp2tNeBB3Dqw@mail.gmail.com>
In-Reply-To: <CALx5=V_Y2=bZWXzc9uQkmTBAECeMLbnPU0VA56Wp2tNeBB3Dqw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2013 10:49 PM, Matt Chen wrote:
> I tried and test the patches for rtl8188ee and rtl8192ce, so far are working
> fine to me. :)
>
> Acked-by: Chen, Chien-Chia <machen@suse.com <mailto:machen@suse.com>>

Thanks for the update. I am still chasing system crashes related to CPU lockups 
caused by spinlock contention. I take it that you have not seen these.

Larry


