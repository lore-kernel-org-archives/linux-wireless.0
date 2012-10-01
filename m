Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4412 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2JAMB5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 08:01:57 -0400
Message-ID: <50698628.9050800@broadcom.com> (sfid-20121001_140200_419664_BB8554D0)
Date: Mon, 1 Oct 2012 14:01:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Jasmine Hassan" <jasmine.aura@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [Kernel Bug] 3.6, wpasupplicant 1.0, broadcom-sta
 6.20.55.19
References: <CAHbMyCb7S1faT_GH8KBag0SVX+7uhC-4qLJOR-DhStpzSMNDqQ@mail.gmail.com>
 <20121001113456.GA31313@tuxdriver.com>
In-Reply-To: <20121001113456.GA31313@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2012 01:34 PM, John W. Linville wrote:
> Why aren't you using brcmsmac?
>

Because the chip is bcm43142. No support for that in brcmsmac.

Gr. AvS


