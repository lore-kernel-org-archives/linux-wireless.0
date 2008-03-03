Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:1342 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277AbYCCVcV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 16:32:21 -0500
Received: by wx-out-0506.google.com with SMTP id h31so361081wxd.4
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 13:32:19 -0800 (PST)
Message-ID: <646765f40803031332o2edc9eecm807bc974ac17dc2@mail.gmail.com> (sfid-20080303_213225_643802_1E6CE957)
Date: Tue, 4 Mar 2008 08:32:18 +1100
From: "Julian Calaby" <julian.calaby@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: Netgear WG311v3 - Marvell 88w8355 "Libertas"
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <1204558117.3155.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <646765f40803020319mf2db1fg9b9a1dde58fcda62@mail.gmail.com>
	 <1204472016.13121.27.camel@localhost.localdomain>
	 <646765f40803021401i65e31e16v5efd0784bffcc177@mail.gmail.com>
	 <1204505713.3070.0.camel@localhost.localdomain>
	 <646765f40803022006h39ec0c43uf9af99924dedc29@mail.gmail.com>
	 <1204558117.3155.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 4, 2008 at 2:28 AM, Dan Williams <dcbw@redhat.com> wrote:
>
> On Mon, 2008-03-03 at 15:06 +1100, Julian Calaby wrote:
>  > On Mon, Mar 3, 2008 at 11:55 AM, Dan Williams <dcbw@redhat.com> wrote:
>  > >
>  > > On Mon, 2008-03-03 at 09:01 +1100, Julian Calaby wrote:
>  > >  > Well, that explains why the "Libertas" parts supported by the current
>  > >  > kernel require firmware and why the ndiswrapper driver I'm using
>  > >  > doesn't.
>  > >
>  > >  The 8335 still requires firmware.  Lots of the windows drivers embed the
>  > >  firmware into the .sys or .dll files, whereas on Linux embedding
>  > >  firmware into the driver is quite frowned upon.
>  >
>  > Yeah, I discovered that the mrv8k driver still requires firmware,
>  > despite there being no actual file in the windows driver that I can
>  > point to as being the firmware image.
>
>  It's likely embedded into the sys file, try:
>
>  http://www.saillard.org/linux/mrv8k/files/mrv8k_extract_fw.c
>
>  to extract the firmware from a supported driver file.  At least one
>  versoin of WG311v3 driver seems to be supported there ("NETGEAR
>  WG311v3", "3.1.1.7") for extracting the firmware from.

Thought as much, I've already downloaded it, and will be trying it out tonight.

Thanks,

(sorry for the dupe, hit the wrong button)

-- 

Julian Calaby

Email: julian.calaby@gmail.com
