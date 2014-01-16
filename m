Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46895 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAPTAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 14:00:21 -0500
Date: Thu, 16 Jan 2014 13:50:16 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3/8] bcma: add agent IOCTL bit values for Broadcom 802.11
 and CR4 cores
Message-ID: <20140116185015.GC10165@tuxdriver.com> (sfid-20140116_200027_288488_7381832C)
References: <1389648029-23560-1-git-send-email-arend@broadcom.com>
 <1389648029-23560-4-git-send-email-arend@broadcom.com>
 <CACna6ryGU_Rc-iJDJWAjjrKLteg7eyPVorasB-cR4sDhE8o8dw@mail.gmail.com>
 <52D6AA49.6000707@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <52D6AA49.6000707@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 15, 2014 at 04:33:29PM +0100, Arend van Spriel wrote:
> On 01/14/2014 07:29 AM, Rafał Miłecki wrote:
> > 2014/1/13 Arend van Spriel <arend@broadcom.com>:
> >> The IOCTL register in the agent/wrapper contains additional bits
> >> that are core specific and use in the core reset sequence.
> > 
> > I'm not sure about this. I don't think we want to keep device-specific
> > bits in a commond (bcma's) code.
> 
> Hi John,
> 
> Given that I agree with Rafał's argument, can you drop patch #3 from
> this series. I applied the other patches using 'git am -3' and that
> works. Let me know if I should resend them.
> 
> Gr. AvS

OK.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
