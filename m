Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:27602 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758611Ab0JSNfD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 09:35:03 -0400
Message-ID: <782419.6815.qm@web56803.mail.re3.yahoo.com>
Date: Tue, 19 Oct 2010 06:35:01 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH] Do not compile staging directory for bt target. Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
To: Bala Shanmugam <sbalashanmugam@atheros.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimoMhytXWm9qh21VGX5B6EoE6JwWyMu1t-ivno9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Applied, you may want a

> 
>   Luis
I was just about to submit exactly the same patch :)

BTW,  I was thinking, perhaps we could merge bt and ethernet drivers in one line, by two separate groups via driver-select. For example:
Replace current: 
"Supported Ethernet drivers: < atl1 atl2 atl1e atl1c >"
with
"Supported Ethernet & Bluetooth drivers: < bt | eth (atlxx) >

or something like that. This will notify users they can actually install bt drivers /if they don't read documentation/.

Its a little weird that, atlxx are provided via driver-select and bt from 'make bt'. I believe they should be "on the same page"

I would also suggest we drop the load.sh and wlload.sh scripts. I can't think of a reason why a sane person would opt for such iffy, redundant and probably malignant way to load their respective driver.

There was something else, but I can't remember now ;)

Walter.


      
