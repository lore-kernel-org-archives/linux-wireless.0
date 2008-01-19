Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:63418 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758649AbYASCE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2008 21:04:57 -0500
Received: by fg-out-1718.google.com with SMTP id e21so1214158fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2008 18:04:55 -0800 (PST)
Message-ID: <9f50a7a00801181804n314bcf09u69889d1a38fb4643@mail.gmail.com> (sfid-20080119_020501_178855_DF464887)
Date: Fri, 18 Jan 2008 20:04:55 -0600
From: "Jerone Young" <jerone@gmail.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Subject: Re: [ipw3945-devel] iwl3945 driver is still unusable!
Cc: "=?ISO-8859-1?Q?Thomas_B=E4chler?=" <thomas@archlinux.org>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <D936D925018D154694D8A362EEB08920036F2DBF@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <fmclu6$dvl$1@ger.gmane.org> <fmpigk$c57$1@ger.gmane.org>
	 <D936D925018D154694D8A362EEB08920036F286F@orsmsx416.amr.corp.intel.com>
	 <47910F33.2090505@archlinux.org>
	 <D936D925018D154694D8A362EEB08920036F2DBF@orsmsx416.amr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the ipw3945 is no longer going to be maintained. You guys should
consider removing it from the mainline kernel. This is in favor of
iwl3945 (which is in the kernel also).

On Jan 18, 2008 3:09 PM, Chatre, Reinette <reinette.chatre@intel.com> w=
rote:
> On Friday, January 18, 2008 12:42 PM, Thomas B=E4chler  wrote:
>
> >> ipw3945 is deprecated - we focus our effort on iwlwifi at this tim=
e.
> >
> > Which doesn't help anyone if it does not work. ipw3945 may be
> > deprecated in your eyes, but for me it is the only way to make my
> > wireless NIC work
> > reliably. From my point of view ipw3945 is stable and iwl3945
> > is _alpha_
> > software.
>
> Please understand that we need to focus limited resources. ipw3945 is=
 deprecated and we focus on iwlwifi, which supports both 3945 and 4965.=
 Unfortunately we have been unable to reproduce your problem.
>
> > It is, but if you read my E-Mail, you will notice that the driver
> > included in 2.6.24 is unusable, thus my request to use a newer driv=
er
> > with a _stable_ kernel. The wireless-dev is based on the latest
> > linux-2.6 git, which is not always stable.
>
> For this purpose I suggest that you consider the compat-wireless proj=
ect. See http://www.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-w=
ireless-2.6.git and http://linuxwireless.org/download/compat-wireless-2=
=2E6/.
>
>
> Reinette
>
>
> ---------------------------------------------------------------------=
----
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Ipw3945-devel mailing list
> Ipw3945-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
