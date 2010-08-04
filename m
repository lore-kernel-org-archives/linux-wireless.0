Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:42072 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab0HDQGT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 12:06:19 -0400
Subject: Re: [PATCH 2.6.35] iwlagn: Improve aggregation failure error
 messages
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <AANLkTik=s32LV5ZUpU5EUBCV6zKsuU5SHM+UD0iS1oyW@mail.gmail.com>
References: <4f999350050decc0901e6f23ae3f06d35bc3fbc0.1280077759.git.luto@mit.edu>
	 <AANLkTik=s32LV5ZUpU5EUBCV6zKsuU5SHM+UD0iS1oyW@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 04 Aug 2010 09:05:43 -0700
Message-Id: <1280937943.11085.0.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Wed, 2010-08-04 at 08:54 -0700, Andrew Lutomirski wrote:
> On Sun, Jul 25, 2010 at 1:14 PM, Andy Lutomirski <luto@mit.edu> wrote:
> > 82ca9341763107615a15da6e59b9535d49eb91c3 added scary looking
> > but harmless error messages.  Make them clearer and make the
> > actual failure message show up with the same severity as the
> > harmless one.
> >
> > Signed-off-by: Andy Lutomirski <luto@mit.edu>
> > ---
> >
> > This is probably 2.6.35 material.  There is no functional regression
> > here, but 2.6.34 worked pretty well and 2.6.35 *looks* like it's not
> > working if you read the logs.
> >
> > There is no functional change in this patch.
> 
> Well, 2.6.35 has come and gone.  Want to take it for 2.6.36 (it was
> submitted in time AFAICT)?
> 
Looks good to me.

Thanks
Wey

