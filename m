Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56806.mail.re3.yahoo.com ([66.196.97.80]:37526 "HELO
	web56806.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754856Ab0IWTKy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 15:10:54 -0400
Message-ID: <718868.40588.qm@web56806.mail.re3.yahoo.com>
Date: Thu, 23 Sep 2010 12:10:53 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: Compiling carl9170
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <AANLkTik6r_xUD4Ct2iuWWbXPLUnDYb1HPzLTaym=GW8L@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> Yes, distributions should pick carl9170 over ar9170 though
> as ar9170
> will be removed from the kernel after a good kernel try out
> of it.
> 
>   Luis

Sounds logical. Shouldn't ar9170 be disabled by default via config.mk in compat-wireless to prevent collision with carl9170 before its completely removed?

Walt.


      
