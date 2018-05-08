Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46791 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754913AbeEHRgw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 May 2018 13:36:52 -0400
Date: Tue, 8 May 2018 17:36:49 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-fbdev@vger.kernel.org,
        linux-can@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@kernel.org>,
        linux-iio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 00/18] Fix some build warnings/errors with Sphinx
Message-ID: <20180508173649.GH27853@wotan.suse.de> (sfid-20180508_193714_423671_E3AC3278)
References: <cover.1525684985.git.mchehab+samsung@kernel.org>
 <20180508101342.2bde20ea@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180508101342.2bde20ea@lwn.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2018 at 10:13:42AM -0600, Jonathan Corbet wrote:
> On Mon,  7 May 2018 06:35:36 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> > I decided to give a try with Sphinx last stable version
> > (1.17.4), and noticed several issues. The worse one was
> > with the networking book: a non-standard footnote there
> > with [*] instead of a number causes it to break PDF building.
> > 
> > So, I took some spare time to address some warnings all over
> > the tree, and moved a few text documents to a book. 
> 
> OK, I've applied the ones that seem to make sense for me to take now.
> There's comments on the firmware one, 

I'll fold in the fixes for the firmware API which do apply to my queue.

  Luis
