Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.189]:53745 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbYCCEGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Mar 2008 23:06:37 -0500
Received: by gv-out-0910.google.com with SMTP id s4so2611345gve.37
        for <linux-wireless@vger.kernel.org>; Sun, 02 Mar 2008 20:06:35 -0800 (PST)
Message-ID: <646765f40803022006h39ec0c43uf9af99924dedc29@mail.gmail.com> (sfid-20080303_040640_963681_5BD607BB)
Date: Mon, 3 Mar 2008 15:06:34 +1100
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Netgear WG311v3 - Marvell 88w8355 "Libertas"
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1204505713.3070.0.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com>
	 <1204472016.13121.27.camel@localhost.localdomain>
	 <646765f40803021401i65e31e16v5efd0784bffcc177@mail.gmail.com>
	 <1204505713.3070.0.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 3, 2008 at 11:55 AM, Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2008-03-03 at 09:01 +1100, Julian Calaby wrote:
>  > Well, that explains why the "Libertas" parts supported by the current
>  > kernel require firmware and why the ndiswrapper driver I'm using
>  > doesn't.
>
>  The 8335 still requires firmware.  Lots of the windows drivers embed the
>  firmware into the .sys or .dll files, whereas on Linux embedding
>  firmware into the driver is quite frowned upon.

Yeah, I discovered that the mrv8k driver still requires firmware,
despite there being no actual file in the windows driver that I can
point to as being the firmware image.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
