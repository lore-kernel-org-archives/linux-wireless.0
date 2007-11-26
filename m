Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.187]:33601 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbXKZRdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:33:21 -0500
Received: by rv-out-0910.google.com with SMTP id k20so599278rvb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 09:33:20 -0800 (PST)
Message-ID: <1ba2fa240711260933x5ed85123vc33d7d3a5e1bd866@mail.gmail.com> (sfid-20071126_173325_546919_C6981A4E)
Date: Mon, 26 Nov 2007 19:33:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH 2/2] iwlwifi: add power management support -v2
Cc: "=?ISO-8859-1?Q?Miguel_Bot=F3n?=" <mboton.lkml@gmail.com>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	yi.zhu@intel.com
In-Reply-To: <1196097270.23210.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200711170006.49654.mboton.lkml@gmail.com>
	 <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
	 <200711261718.14711.mboton@gmail.com>
	 <1ba2fa240711260911i705350f3hefeddc7a09f76d1a@mail.gmail.com>
	 <1196097270.23210.0.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> At some point everyone needs to standardize on power levels so that
> userland has a hope of mapping the right state to the right power lev=
el
> in the driver.  Otherwise, we get into a situation where broadcom pow=
er
> levels don't map the same way iwl powerlevels do, and then we can't e=
ver
> do the right thing.
>
Agree, these are just misleading  names IMHO.

> dan
>
> > Tomas
>
> >
> > > --
> > >        Miguel Bot=F3n
> > >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-wir=
eless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
