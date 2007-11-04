Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:11330 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbXKDK2j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Nov 2007 05:28:39 -0500
Received: by fk-out-0910.google.com with SMTP id z23so1279084fkz
        for <linux-wireless@vger.kernel.org>; Sun, 04 Nov 2007 02:28:37 -0800 (PST)
Message-ID: <472D9ED3.6000202@gmail.com> (sfid-20071104_102844_783416_46C0247A)
Date: Sun, 04 Nov 2007 11:28:35 +0100
From: drago01 <drago01@gmail.com>
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] iwl3945 in 2.6.24-rc1 dies under load
References: <20071031005202.GA1534@elf.ucw.cz>	<1193792098.9704.16.camel@debian.sh.intel.com>	<20071101001221.GA1755@elf.ucw.cz>	<1193881026.31257.52.camel@debian.sh.intel.com> <20071103183446.GD13202@elf.ucw.cz>
In-Reply-To: <20071103183446.GD13202@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Machek wrote:
> BTW... the wireless light does not seem to work on x60. It used to
> work with some -mm versions...
>   
iwl3945 and ilw4965 don't support the wireless leds. There is a patch on 
this list that enables it but it is not merged yet.


