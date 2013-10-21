Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:62684 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3JUQUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 12:20:06 -0400
Received: by mail-ob0-f169.google.com with SMTP id wp4so6082066obc.28
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 09:20:03 -0700 (PDT)
Message-ID: <52655431.9050805@lwfinger.net> (sfid-20131021_182011_029026_830906C2)
Date: Mon, 21 Oct 2013 11:20:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Moes <mark_moes@live.nl>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 AP/Master mode
References: <DUB119-W4654D1E1A8377FA92B6E049E010@phx.gbl> <DUB119-W4825EB1294BF48BA2BAAB39E010@phx.gbl>
In-Reply-To: <DUB119-W4825EB1294BF48BA2BAAB39E010@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/21/2013 06:21 AM, Mark Moes wrote:
> Hi,
>
>
> I was wondering if there's any work being done on the AP/Master mode implementation of the rtl8187 chip as listed here: http://wireless.kernel.org/en/users/Drivers/rtl8187
>
> If not, could anyone give a guesstimate of how much work is needed to write the code for this functionality?

The RTL8187L chip does not implement QoS queuing. It might work in an AP, but it 
would certainly fall over with a heavy load. The RTL8187B might work better. 
When you add the fact that the internal workings of these chips are unpublished 
and unknown to us, implementing either AP or Master mode would likely be difficult.

It is impossible to guesstimate the time required. All that I can tell you is 
that adapting this driver to work with either of these two modes is very low on 
my priority list.

Larry




