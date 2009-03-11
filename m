Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:7432 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbZCKDLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 23:11:24 -0400
Received: by rv-out-0506.google.com with SMTP id g37so2526181rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 20:11:22 -0700 (PDT)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236709365.3911.1.camel@abhi-desktop>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236194370.6612.73.camel@rc-desk>
	 <c4d76b3b0903041147s2138e72bjb39864f87b4cd09e@mail.gmail.com>
	 <1236211493.6612.90.camel@rc-desk> <1236297052.6153.4.camel@rainbow>
	 <1236299085.6612.229.camel@rc-desk>	 <1236312734.19328.37.camel@rainbow>
	 <1236317982.12430.9.camel@rc-desk>	 <1236649234.6685.9.camel@rainbow>
	 <1236661466.15923.53.camel@rc-desk>
	 <c4d76b3b0903100610v21da8728l1414ca0187f29376@mail.gmail.com>
	 <1236709365.3911.1.camel@abhi-desktop>
Content-Type: text/plain
Date: Tue, 10 Mar 2009 23:11:15 -0400
Message-Id: <1236741075.6466.1.camel@rainbow> (sfid-20090311_041128_702367_3DE1384A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-03-10 at 11:22 -0700, Abhijeet Kolekar wrote:
> Jason,
>   Can you take a look at the patch and test it? I am not sure how the
> tip of your git looks like but you can make changes easily by looking at
> the patch.

There was an Oops very shortly after modprobing the module.  I did not
have a netconsole setup, so I could not catch it.

Jason

