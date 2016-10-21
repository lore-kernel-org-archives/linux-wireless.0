Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60852 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754049AbcJUMbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Oct 2016 08:31:42 -0400
Message-ID: <1477053099.4068.42.camel@sipsolutions.net> (sfid-20161021_143146_597279_137FBA49)
Subject: Re: sequence diagrams in rst documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-wireless@vger.kernel.org,
        linux-doc <linux-doc@vger.kernel.org>
Date: Fri, 21 Oct 2016 14:31:39 +0200
In-Reply-To: <1476863488.5927.10.camel@sipsolutions.net>
References: <1476190613-2403-1-git-send-email-johannes@sipsolutions.net>
         <20161011072119.7ad4e3a3@lwn.net>
         <1476193466.4118.10.camel@sipsolutions.net>
         <1476194038.4118.11.camel@sipsolutions.net>
         <1476791021.6425.25.camel@sipsolutions.net>
         <20161018175236.75c8c4e2@lwn.net>
         <1476863488.5927.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> > 	https://pythonhosted.org/sphinxcontrib-aafig/
> > 
> > I've not actually played with it at all, but I like the idea that
> > we'd have readable diagrams in the source docs as well...
> 
> Well, maybe. I agree having it readable in the source docs as well is
> nice, but for sequence diagrams in particular, I don't think
> 
>     +-------+         +-----------+
>     | Hello +-------->+ aafigure! |
>     +-------+         +-----------+
> 
> really beats
> 
>    Hello -> aafigure!


I found another one:

https://pypi.python.org/pypi/sphinxcontrib-plantuml

That one has really nice output and features, but ends up being a
*java* (of all the things) tool that the thing calls out to ...


Perhaps we can have a compromise and embed the raw text when the
tooling isn't all installed, so you can still build useful
documentation, but to get all the "prettiness" you might have to
install more dependencies?

johannes
