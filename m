Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.224]:24097 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXIVScF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Sep 2007 14:32:05 -0400
Received: by qb-out-0506.google.com with SMTP id e11so868934qbe
        for <linux-wireless@vger.kernel.org>; Sat, 22 Sep 2007 11:32:04 -0700 (PDT)
Message-ID: <40f31dec0709221132q4e65b975s4e1fa402beab065@mail.gmail.com>
Date: Sat, 22 Sep 2007 21:32:04 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH] ath5k - Fix filters for AR5212, correct return values for WEP
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <46F2E56D.1040606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890709201413w4cee6ea5v799f4b88e1982e5a@mail.gmail.com>
	 <46F2E3A9.2040605@gmail.com>
	 <43e72e890709201424k3a18a5cbnbbb488dbf5bb19d3@mail.gmail.com>
	 <46F2E56D.1040606@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ppl can someone plz port also these changes from madwifi svn ??? Sorry
for not doing this myself i'm really out of time these days...

http://madwifi.org/changeset/2704
http://madwifi.org/changeset/2703
http://madwifi.org/changeset/2701
http://madwifi.org/changeset/2700
http://madwifi.org/changeset/2698

2007/9/21, Jiri Slaby <jirislaby@gmail.com>:
> On 09/20/2007 11:24 PM, Luis R. Rodriguez wrote:
> > On 9/20/07, Jiri Slaby <jirislaby@gmail.com> wrote:
> >     int ret = 0;
> >> +       switch(key->alg) {
> >> +        case ALG_WEP:
> >> +               break;
> >> +        case ALG_TKIP:
> >> +        case ALG_CCMP:
> >> +               return -EOPNOTSUPP;
> >>
> >> Some broken whitespace here :).
> >
> > You mean all the extra spaces on the left instead of Tabs? If so then
> > ACK, attached v2.
>
> Yes, nice.
>
> --
> Jiri Slaby (jirislaby@gmail.com)
> Faculty of Informatics, Masaryk University
>


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
