Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:3726 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbYJNJYH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 05:24:07 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810140213w291d729cl6c1bd1149109320d@mail.gmail.com>
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <43e72e890810140213w291d729cl6c1bd1149109320d@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 14 Oct 2008 17:23:31 +0800
Message-Id: <1223976211.2570.177.camel@debian.sh.intel.com> (sfid-20081014_112412_271000_FF0376F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-10-14 at 02:13 -0700, Luis R. Rodriguez wrote:
> I believe your issue is that your "regulatory domain" is not a
> regulatory domain but hw capabilities so this is why you asked me what
> values to add in case 2, please correct me if I'm wrong. In that case
> -- yes, you should add regulatory rules even if the card is only
> single band; but you can't because you don't have that information in
> your driver. So you should just go with what you have and that is to
> only provide the hardware capabilities. In that case a single band
> card will report according to its regulatory info it can only work on
> the 2 GHz band while a dual band card will report both 2 GHz and 5
> GHz. The intersection is still 2 GHz.

Yes, this is exact my problem. Do you any better way to solve it?

Thanks,
-yi

