Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:18682 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZDAB2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 21:28:14 -0400
Received: by yw-out-2324.google.com with SMTP id 5so2721120ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 18:28:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238538161.10366.144.camel@rc-desk>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
	 <1237581564.21165.5.camel@abhi-desktop>
	 <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com>
	 <1237768621.8764.13.camel@rainbow>
	 <1238538161.10366.144.camel@rc-desk>
Date: Tue, 31 Mar 2009 21:28:12 -0400
Message-ID: <c4d76b3b0903311828x48a3f162yc8394f053d7749c9@mail.gmail.com> (sfid-20090401_032818_726715_EAD4CBB6)
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: Jason Andryuk <jandryuk@gmail.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 31, 2009 at 6:22 PM, reinette chatre
<reinette.chatre@intel.com> wrote:
> Could you please try this patch?

It is working for me on iwl3945.  I am associated to my AP and
streaming a video off the internet (10 minutes so far).

Thanks,

Jason
