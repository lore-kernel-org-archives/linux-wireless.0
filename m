Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.233]:50877 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbYJNHEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 03:04:25 -0400
Received: by wr-out-0506.google.com with SMTP id 69so1293774wri.5
        for <linux-wireless@vger.kernel.org>; Tue, 14 Oct 2008 00:04:23 -0700 (PDT)
Message-ID: <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com> (sfid-20081014_090428_379731_98F7F4D1)
Date: Tue, 14 Oct 2008 00:04:23 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Zhu Yi" <yi.zhu@intel.com>
Subject: Re: New Regulatory Domain Api.
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223967581.2570.144.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 13, 2008 at 11:59 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Fri, 2008-10-10 at 09:49 -0700, Luis R. Rodriguez wrote:
>> The real correct behavior here, as the comment also
>> indicates, is we should be doing an intersection between the two
>> regulatory domains and I sent a RFC on a some initial code I had to
>> support such intersection. Until that is not merged we just respect
>> first regulatory request.
>
> Why should the intersection be the correct behavior? In my previous
> example, the intersection of a BG card and an ABG card is the BG bands.
> Why shouldn't the ABG card have the A band support?

Intersection of ABG and BG is BG.

  Luis
