Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb.errno.com ([69.12.149.25]:4950 "EHLO ebb.errno.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963AbYGJQMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 12:12:08 -0400
Message-ID: <4876304E.9070508@errno.com> (sfid-20080710_181215_567825_155BAA48)
Date: Thu, 10 Jul 2008 08:52:46 -0700
From: Sam Leffler <sam@errno.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC] Add new regulatory framework for Linux wireless
References: <20080710152415.GK17936@ruslug.rutgers.edu>
In-Reply-To: <20080710152415.GK17936@ruslug.rutgers.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> The industry currently has different techniques for parsing and using
> Country IEs. What I currently propose is to take the common denominator
> between what the AP provides, what CRDA has and what the driver can
> provide privately through its callback. So the wireless core can keep
> as the common denominator between the AP's Country IE and what CRDA
> has for the alpha2 provided by the Country IE. Drivers themselves can
> further enhance regulatory enforcement by relying on private driver
> data if they wish so.
>
>   
Can you elaborate on the first sentence?  Are you just saying that some 
software blindly trusts the contents of the country IE and doesn't 
constrain it's use (as you describe)?  Or are you saying drivers 
interpret the contents of the country IE in ways different than spec'd?

    Sam

