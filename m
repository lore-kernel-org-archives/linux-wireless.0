Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:49444 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751861AbdLMJQk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Dec 2017 04:16:40 -0500
Subject: Re: net/wireless/shipped-certs.c:2:1: error: expected expression at
 end of input
To: Damian Tometzki <damian.tometzki@icloud.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <4006aefb-e9af-d809-b45a-201d20e75f9d@molgen.mpg.de>
 <1512468219.26976.15.camel@sipsolutions.net>
 <8617D3B1-DE6C-4E75-AB44-1845806E18D6@icloud.com>
From: Paul Menzel <pmenzel+linux-wireless@molgen.mpg.de>
Message-ID: <f091f30c-3681-6e6e-774c-3906026c573e@molgen.mpg.de> (sfid-20171213_101645_851701_236FFD7E)
Date: Wed, 13 Dec 2017 10:16:38 +0100
MIME-Version: 1.0
In-Reply-To: <8617D3B1-DE6C-4E75-AB44-1845806E18D6@icloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Damian,


On 12/13/17 08:53, Damian Tometzki wrote:

> I got. the same Build error.

So first you didn’t have hexdump installed, and then after installing it 
you got it? Removing the generated file fixed the build?


Kind regards,

Paul
