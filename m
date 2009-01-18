Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:2251 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbZARS5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 13:57:41 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1098815yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2009 10:57:40 -0800 (PST)
Message-ID: <43e72e890901181057n770a177ax63ba3b4ec3d7e66a@mail.gmail.com> (sfid-20090118_195815_005528_5F6BEB4E)
Date: Sun, 18 Jan 2009 10:57:40 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>,
	"Javier Cardona" <javier@cozybit.com>,
	"Dan Williams" <dcbw@redhat.com>,
	madwifi-project@lists.madwifi-project.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [madwifi-team] Using orbit
Cc: "Ivan Seskar" <Seskar@winlab.rutgers.edu>
In-Reply-To: <43e72e890810021037x49b0de85r6cac065720af3be@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890810021037x49b0de85r6cac065720af3be@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 2, 2008 at 9:37 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Oct 2, 2008 at 8:12 AM, Michael Renzmann <mrenzmann@madwifi.org> wrote:
>
>> Is Orbit still an option for our testbed plans?
>
> Absolutely, even for the "madwifi" driver, anything the team needs. In
> fact I've extended the offer to use the grid to OpenBSD and FreeBSD
> too. Although I don't work there fulltime I'm still part of Orbit and
> will be managing their "open source" accounts. I intend on eventually
> getting a test plan done but of course test stuff is always last
> priority on the list of things to do :(. At OLS2008 Dan Williams
> showed interest in this too.
>
> I should mention that most of my desires to test software are now
> resolved through mac80211_hwsim driver -- mac80211 can be thoroughly
> tested using this, so the grid/sandboxes are useful for real driver
> testing and for experiments.
>
> I have a 2.6.27 based image there now (baseline-8.9-dev.ndz), and
> compat-wireless available from /usr/src/, with the git tree used
> through autofs (which is updated daily), so to update the drivers and
> install them all you have to do run the compat-wireless
> admin-update.sh and then compile and install.
>
> Testing AP for example on ath5k is ideal here too as the nodes on
> Sanboxes are hooked up together through attenuators directly. Note
> that there are two wireless cards on each node, and the sanboxes have
> two nodes. Each wireless cards is paired up with the other one on the
> other node in a sandbox. Anyway if you'd like an account let me know.
>
> PS. Testing mesh should be possible now too using the
> baseline-8.9-dev.ndz (2.6.27 based) and updating compat-wireless.

BTW you can now request an account here:

http://www.orbit-lab.org/register

For organization select "Linux Wireless Networking"

  Luis
