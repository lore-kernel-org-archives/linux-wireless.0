Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:1286 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab1EXVVB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 17:21:01 -0400
Message-ID: <4DDC213C.1080708@gnu.org> (sfid-20110524_232106_290629_AFE23948)
Date: Tue, 24 May 2011 17:21:00 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Eduard GV <eduardgv@gmail.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com, Matt Smith <Matt.Smith@atheros.com>
Subject: Re: Initial automatic channel selection implementation
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>	<201105241627.49201.helmut.schaa@googlemail.com> <BANLkTi=o5XFTK8d3B-PsKh95ELbWMuVPwA@mail.gmail.com>
In-Reply-To: <BANLkTi=o5XFTK8d3B-PsKh95ELbWMuVPwA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 02:07 PM, Eduard GV wrote:
>
>> Speaking of channels, I think only some channels should be eligible for
>> automatic selection (that would be 1, 6 and 11 in the 2.4 GHz range).
>
> I disagree. Sometimes it is better to have adjacent channel
> interference (from partially overlapping channels) than co-channel
> interference. I could provide some references if you're interested.

My point is that we should play safe, at least when the algorithm is 
simple.  We should try to avoid the situation when our AP chooses a 
channel with no other APs but with a lot of cross-channel interference 
(either at the time of the scanning or later).

-- 
Regards,
Pavel Roskin
