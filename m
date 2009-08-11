Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:34614 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbZHKToM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 15:44:12 -0400
Message-ID: <4A81C9F4.4070000@nokia.com>
Date: Tue, 11 Aug 2009 22:43:48 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
MIME-Version: 1.0
To: "ext John W. Linville" <linville@tuxdriver.com>
CC: ext Stephen Rothwell <sfr@canb.auug.org.au>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wl1271: fix compiler warnings on 64 bit archs
References: <1249981107-21746-1-git-send-email-luciano.coelho@nokia.com> <20090811200746.cde6aed9.sfr@canb.auug.org.au> <4A81BB47.2020607@nokia.com> <20090811191518.GI2634@tuxdriver.com>
In-Reply-To: <20090811191518.GI2634@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext John W. Linville wrote:
> On Tue, Aug 11, 2009 at 09:41:11PM +0300, Luciano Coelho wrote:
>   
>> Thanks! I didn't know about the z length modifier for printf (everyday  
>> learning something new!), I should have checked the manpage.  I'll fix  
>> this and send v2 of my patch.
>>     
>
> I've got it fixed-up already...
>   

Thanks, I noticed that it was already fixed in wireless-next after I had 
already sent v2.  Sorry for the trouble.

-- 
Cheers,
Luca.

