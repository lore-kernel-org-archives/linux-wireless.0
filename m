Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab3K3N5V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 08:57:21 -0500
In-Reply-To: <CAHNKnsSZxMscirbW=BqTa7fPXDUeFp67Co=QEtawjSOmctfs9Q@mail.gmail.com> (sfid-20131130_143629_082318_54DF89AF)
References: <CAGXs5wXPB2WvuxfXzuyDaGS5_cA+GG5vHkHO+PnnVncvOwJTDg@mail.gmail.com> <1385817282.5056.0.camel@jlt4.sipsolutions.net> <CAHNKnsSZxMscirbW=BqTa7fPXDUeFp67Co=QEtawjSOmctfs9Q@mail.gmail.com> (sfid-20131130_143629_082318_54DF89AF)
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: wireless network interfaces and network namespaces
From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 30 Nov 2013 14:57:16 +0100
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
CC: Kevin Wilson <wkevils@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Message-ID: <0ebc7750-bd66-4613-b90d-3030f4de82b0@email.android.com> (sfid-20131130_145723_660703_226FC1A2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
>2013/11/30 Johannes Berg <johannes@sipsolutions.net>:
>> having different virtual interfaces of the same NIC in different
>> namespaces is not supported.
>>
>Is this rule applicable to hwsim interfaces too?

Yes. Hwsim should work with namespaces.
