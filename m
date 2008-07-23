Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:30248 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYGWXeJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 19:34:09 -0400
Received: by ik-out-1112.google.com with SMTP id c28so1882620ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 16:34:06 -0700 (PDT)
Date: Wed, 23 Jul 2008 18:35:34 -0500
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tomasw@gmail.com, tytso@mit.edu, yi.zhu@intel.com,
	reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: Potential iwlwifi locking problem in 2.6.26-git9
Message-ID: <20080723233534.GA9975@localhost> (sfid-20080724_013414_709927_380FCE2D)
References: <20080723214938.GA8034@mit.edu> <1ba2fa240807231502t1c4ce7d5k9b8acbcaed4d166a@mail.gmail.com> <20080723225820.GA4099@localhost> <20080723.161100.219406395.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080723.161100.219406395.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 23.Jul'08 at 16:11:00 -0700, David Miller wrote:
> From: "Carlos R. Mafra" <crmafra2@gmail.com>
> Date: Wed, 23 Jul 2008 17:59:06 -0500
> 
> > I am trying to bisect it, but I am facing some difficulties with compilation
> > problems and non-booting kernels.
> 
> We know what the problem is and are discussing it on netdev
> and linux-wireless already.

Thank you for letting me know, David!
I appreciate that deeply.
