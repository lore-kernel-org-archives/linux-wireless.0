Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:41011 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbZAORql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2009 12:46:41 -0500
From: Paul Moore <paul.moore@hp.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: netlabel: UNLABELED ath9k not denying unlabeled traffic
Date: Thu, 15 Jan 2009 12:46:38 -0500
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	"SE-Linux" <selinux@tycho.nsa.gov>
References: <496D759A.7010401@gmail.com> <200901141736.43805.paul.moore@hp.com> <496EA2EC.7030602@gmail.com>
In-Reply-To: <496EA2EC.7030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901151246.38396.paul.moore@hp.com> (sfid-20090115_184646_771352_8FEF3F0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 January 2009 9:43:56 pm Justin P. Mattock wrote:
> Paul Moore wrote:
> > On Wednesday 14 January 2009 4:35:25 pm Justin P. Mattock wrote:
> >> here is what the error looks like:
> >>
> >> netlabel_tools-0.19# make
> >> INFO: creating the version header file
> >> .: 10: version_info: not found
> >> make: *** [include/version.h] Error 2
> >
> > Huh, can you try the following:
> >
> >  1. Open the netlabel_tools-0.19/Makefile in your favorite editor
> >  2. Change the ". version_info; \" line to "source ./version_info;
> > \" 3. Save your changes
> >  4. Try running "make" again
> >
> > Thanks.
>
> O.k. changed . version like how you had posted.
> The package compiled like a charm.

Great, I'll change the Makefile(s) in SVN ... I don't quite understand 
the reason (what is your /bin/sh?  I'm guessing not bash?) but at least 
we now have a solution :) 

-- 
paul moore
linux @ hp
