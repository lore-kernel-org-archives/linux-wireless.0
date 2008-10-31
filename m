Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.183]:48520 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbYJaSft (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 14:35:49 -0400
Message-ID: <40f31dec0810311135w76c01729lef1a6c93f18c0095@mail.gmail.com> (sfid-20081031_193554_374046_B37D6F53)
Date: Fri, 31 Oct 2008 20:35:47 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Matthew Garrett" <mjg59@srcf.ucam.org>
Subject: Re: ath5k gets lost with eeepc-laptop removal
Cc: "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
	"Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@linux.intel.com, lrodriguez@atheros.com
In-Reply-To: <20081031142318.GA9009@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081031110502.18e33eba@doriath.conectiva>
	 <490B0D75.8020601@tuffmail.co.uk>
	 <20081031142318.GA9009@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/31 Matthew Garrett <mjg59@srcf.ucam.org>:
> On Fri, Oct 31, 2008 at 01:51:49PM +0000, Alan Jenkins wrote:
>
>> Matthew: I nagged you twice about different consequences of this
>> commit, so here's a third :).  You said rfkill no longer automatically
>> frobs on suspend/resume, which was what I was worried about last time.
>> Should the core code also be modified so it doesn't do anything when
>> the rfkill device is unregistered?
>
> I think there's definitely an argument in favour of that, though I
> suspect that's a design feature - if you remove the control mechanism
> for a radio, the safe state for that radio to be in is not transmitting.
>

It doesn't leave the radio in a state that's not transmitting, it
leaves the card in a state that doesn't get any power at all. I don't
see any reason for this, how do you define "safe" ?



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
