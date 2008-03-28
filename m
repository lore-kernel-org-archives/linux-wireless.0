Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:57988 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYC1BCI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Mar 2008 21:02:08 -0400
Received: by el-out-1112.google.com with SMTP id z25so11469ele.15
        for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2008 18:02:05 -0700 (PDT)
Message-ID: <1ba2fa240803271802w261394a0y7aee01928368922e@mail.gmail.com> (sfid-20080328_010212_733758_3C0187CE)
Date: Fri, 28 Mar 2008 03:02:04 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] iwlwifi: do not register bands with no supported channels
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com
In-Reply-To: <20080327205359.GA17267@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1206475120-10188-1-git-send-email-linville@tuxdriver.com>
	 <1ba2fa240803251331y60f3cf58x8f08bd4411b1369d@mail.gmail.com>
	 <20080325212407.GB20488@tuxdriver.com>
	 <1ba2fa240803251645r1f034c5enf880c0ffbb830a1a@mail.gmail.com>
	 <20080327205359.GA17267@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 27, 2008 at 10:53 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Mar 26, 2008 at 01:45:03AM +0200, Tomas Winkler wrote:
>
>  > >  I don't think your version will resolve the issue.  Am I missing
>  > >  something?
>  >
>  > Yep I was a bit snappy. my suggestion doesn't resolve the problem.
>  > Anyhow, let me look at this tomorrow if we have other SKU issues so it
>  > can be rolled in together.
>
>  I'm going to go ahead and push mine with todays patches.  Feel free
>  to correct it later if there is some more appropriate test.
>
>  Thanks,

Fine with me. I just got the material about SKUs few hours ago so I
won't be ready with fixes till Sunday.

Tomas
>
>
