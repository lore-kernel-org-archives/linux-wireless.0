Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2793 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030462Ab2CFNmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 08:42:40 -0500
Message-ID: <4F561443.1040506@broadcom.com> (sfid-20120306_144244_993761_B1F6357D)
Date: Tue, 6 Mar 2012 14:42:27 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	b43-dev-list <b43-dev@lists.infradead.org>
Subject: Re: [RFC] bcma: replace ssb_sprom structure with bcma_sprom
 structure
References: <1331036818-9240-1-git-send-email-arend@broadcom.com>
 <CACna6rx5_wds1gMA+9Yg4hMS1NCankwEqN3ixMUaktLAhw9ERw@mail.gmail.com>
In-Reply-To: <CACna6rx5_wds1gMA+9Yg4hMS1NCankwEqN3ixMUaktLAhw9ERw@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/06/2012 02:27 PM, Rafał Miłecki wrote:
> 2012/3/6 Arend van Spriel<arend@broadcom.com>:
>> BCMA shared a structure with SSB in which sprom data was stored. This
>> could have been appropriate but with upcoming srom revisions that are
>> of no interest to SSB it is better to have own definitions with BCMA.
>>
>> This patch adds support for srom revisions 8 and 9.
>
> Does b43 even compile with that?
>

Nope. It does not. That is why I was asking b43 developers for feedback 
in this RFC. By moving to another structure there is more work involved 
that needs good b43 knowledge (which I am lacking). What I can do is 
provide a function that maps bcma_sprom structure members to ssb_sprom 
structure members to make the transition easier.

Gr. AvS

