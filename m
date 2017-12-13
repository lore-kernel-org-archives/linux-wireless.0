Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pv33p00im-asmtp003.me.com ([17.142.194.252]:49700 "EHLO
        pv33p00im-asmtp003.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752886AbdLMOdv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 09:33:51 -0500
Date: Wed, 13 Dec 2017 14:33:33 +0100
From: Damian Tometzki <damian.tometzki@icloud.com>
To: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net/wireless/shipped-certs.c:2:1: error: expected expression at
 end of input
Message-id: <20171213133333.GA25958@zrhn9910b> (sfid-20171213_153412_375492_0892E39A)
References: <4006aefb-e9af-d809-b45a-201d20e75f9d@molgen.mpg.de>
 <1512468219.26976.15.camel@sipsolutions.net>
 <8617D3B1-DE6C-4E75-AB44-1845806E18D6@icloud.com>
 <f091f30c-3681-6e6e-774c-3906026c573e@molgen.mpg.de>
 <7AC5C6E6-E2EE-473D-A8C8-5D18646C93CD@icloud.com>
 <05419671-31e3-f8d0-f293-55c9c22165e4@molgen.mpg.de>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
In-reply-to: <05419671-31e3-f8d0-f293-55c9c22165e4@molgen.mpg.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 13. Dec 12:07, Paul Menzel wrote:
> Dear Damian,
> 
> 
> On 12/13/17 12:00, Damian Tometzki wrote:
> 
> >Hexdump was already installed in the System.
> >
> >I commented out this step.
> Please try to reproduce it from a clean environment (`git clean -dfx`, save
> your .config before), and then please give more details.

After cleaning the environment with  'git clean -dfx' the build was successfully. 
Thanks for you help
 
> 
> 
> Kind regards,
> 
> Paul
