Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.236]:32685 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbYDWBQm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 21:16:42 -0400
Received: by wx-out-0506.google.com with SMTP id h31so2039968wxd.4
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2008 18:16:42 -0700 (PDT)
Subject: Re: 11h IE conflicts with 11s
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Javier Cardona <javier@cozybit.com>, bdm@fenrir.org.uk
In-Reply-To: <1ba2fa240804221723l51b8c9a1qa301ededf6c11336@mail.gmail.com>
References: <1ba2fa240804221003o25515740r71c3210d3c9ffb91@mail.gmail.com>
	 <1208885207.31429.43.camel@johannes.berg>
	 <1ba2fa240804221723l51b8c9a1qa301ededf6c11336@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 18:16:38 -0700
Message-Id: <1208913398.13800.8.camel@localhost> (sfid-20080423_031727_521310_83F4B3AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-23 at 03:23 +0300, Tomas Winkler wrote:
> It's in 7.3.2 table 20 in 11h draft I have here and in table 26 in
> 11ma (unified version)
> These numbers are being used for few years already. This is what for
> example Cisco APs are using
> so I have strong feeling it won't change.
> 
> Not sure why you are looking for it in 11n spec
> 
> I suggest we renumber MESH stuff.

I agree, will try to send a patch tomorrow.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


