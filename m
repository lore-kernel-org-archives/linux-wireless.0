Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:21098 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934814AbXEHJrf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2007 05:47:35 -0400
Received: by ug-out-1314.google.com with SMTP id 44so83804uga
        for <linux-wireless@vger.kernel.org>; Tue, 08 May 2007 02:47:34 -0700 (PDT)
Message-ID: <84144f020705080247v74ebcd26y27c2f1e61529b215@mail.gmail.com>
Date: Tue, 8 May 2007 12:47:34 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Jeff Garzik" <jeff@garzik.org>
Subject: Re: Please pull 'revert-libertas' branch of wireless-2.6 (was Re: Please pull 'libertas' branch of wireless-2.6)
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"Christoph Hellwig" <hch@infradead.org>,
	linux-wireless@vger.kernel.org, marcelo@kvack.org,
	linux-kernel@vger.kernel.org,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <463F443A.5000306@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070227205649.GH5826@tuxdriver.com> <45E8CF5E.5090305@garzik.org>
	 <20070303052140.GA31075@infradead.org>
	 <20070507104117.GA31601@infradead.org>
	 <1178539423.3032.24.camel@localhost.localdomain>
	 <20070507141143.GB5125@tuxdriver.com> <463F443A.5000306@garzik.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/7/07, Jeff Garzik <jeff@garzik.org> wrote:
> Open source is about release early, release often.  Not "hide code in a
> dark corner until Christoph thinks it is perfect."  We have high
> standards for upstream merged code, but that standard is not perfection.

Please. This has nothing to do with Christoph. (1) the driver seems to
break every Linux coding style convention known to man and (2) adds a
new ABI with bunch of ioctls() that apparently haven't been reviewed
properly. That's just not acceptable for mainline kernel!

                               Pekka
