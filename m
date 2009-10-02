Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:44698 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212AbZJBPAT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 11:00:19 -0400
Date: Fri, 2 Oct 2009 07:38:00 -0700
From: Greg KH <gregkh@suse.de>
To: Norbert Preining <preining@logic.at>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mattia Dongili <malattia@linux.it>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: sony-laptop: check for rfkill hard block at load time
Message-ID: <20091002143800.GC21025@suse.de>
References: <20091002100029.GC4406@gandalf.dynalias.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20091002100029.GC4406@gandalf.dynalias.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 02, 2009 at 07:00:29PM +0900, Norbert Preining wrote:
> On Thu, 24 Sep 2009, Alan Jenkins wrote:
> > We can fix this by querying the firmware at load time and calling
> > rfkill_set_hw_state().
> 
> The bug concerning checking the state after suspend to ram should probably
> be also queued. Original email attached.

Queued for what?

confused,

greg k-h
