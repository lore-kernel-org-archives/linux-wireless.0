Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:40388 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaI0GmK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Sep 2014 02:42:10 -0400
In-Reply-To: <1411760678.18773.5.camel@dubbel>
References: <541F23D2.90600@gmail.com> <1411327338-23099-13-git-send-email-egrumbach@gmail.com> <87ppeoc4s0.fsf@nemi.mork.no> <0BA3FCBA62E2DC44AF3030971E174FB31B5261F1@hasmsx107.ger.corp.intel.com> <87d2amd24t.fsf@nemi.mork.no> <0BA3FCBA62E2DC44AF3030971E174FB31B526977@hasmsx107.ger.corp.intel.com> <1411760678.18773.5.camel@dubbel>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH 13/17] iwlwifi: 8000: fix fw name to account for revision
From: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Date: Sat, 27 Sep 2014 08:41:55 +0200
To: Luca Coelho <luca@coelho.fi>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: Emmanuel Grumbach <egrumbach@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kaufman, Liad" <liad.kaufman@intel.com>
Message-ID: <A66968BA-6B95-4437-8A95-5EBFD6BCF583@mork.no> (sfid-20140927_084213_688218_13D9F0EE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26 September 2014 21:44:38 CEST, Luca Coelho <luca@coelho.fi> wrote:

>Yeah, the temperature sensor is used to avoid heating the NIC too much
>and potentially damaging things.  We do things like throttle down the
>data flow and, in the most dramatic cases, turn the chip entirely off.
>
>The mean reason for the new debugfs entry is for, well, debugging. :)
>
>Bjørn, do you have any ideas on how this information could be used in a
>useful way so that it would be worth the effort of exporting it in a
>more "official" way?

No, not really. It was just a random thought that this should be made available for monitoring applications.

It sounds like this sensor is similar to the sensors associated with each CPU core. Which have been made available through the coretemp driver although I don't think that was the intention of the hardware designer. But I don't know if exporting it has any practical value.


Bjørn
