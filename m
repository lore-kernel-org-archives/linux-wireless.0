Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.230]:14278 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbXJZPXw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 11:23:52 -0400
Received: by nz-out-0506.google.com with SMTP id s18so845129nze
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2007 08:23:51 -0700 (PDT)
Message-ID: <f6ca9fed0710260823u302cc2cco6dab40100870dbf8@mail.gmail.com> (sfid-20071026_162400_404498_EAEC0F30)
Date: Fri, 26 Oct 2007 17:23:50 +0200
From: dragoran <drago01@gmail.com>
To: "Jes Sorensen" <jes@sgi.com>
Subject: Re: iwl4965 detection problem
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <4722051E.8080302@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47209C0C.5010505@sgi.com>
	 <1193319925.5542.8.camel@localhost.localdomain>
	 <4720A509.2070708@sgi.com>
	 <1193333545.2111.8.camel@localhost.localdomain>
	 <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com>
	 <4721E17E.2020908@sgi.com> <4721F55F.1030303@sgi.com>
	 <4722051E.8080302@sgi.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/26/07, Jes Sorensen <jes@sgi.com> wrote:
> Jes Sorensen wrote:
> > I haven't had a chance to build the driver with this change, ie. it's
> > untested, but I have a suspicion that this patch might do the job.
>
> So, tested a kernel with this patch applied, and voila! My wireless
> now works on first boot!
>
> Should I post it to linux-kernel or Andrew or will someone on this list
> collect it and push it upstream?

posting it here is enough.
you should add 3945 repost it in a new thread.
