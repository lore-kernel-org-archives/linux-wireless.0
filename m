Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:10098 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYC1Hn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 03:43:29 -0400
Received: by wa-out-1112.google.com with SMTP id v27so162170wah.23
        for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 00:43:27 -0700 (PDT)
Message-ID: <1ba2fa240803280043g7d0fea74vd76691d836900c15@mail.gmail.com> (sfid-20080328_074333_689751_15BFD2B0)
Date: Fri, 28 Mar 2008 10:43:27 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: TKIP patches
Cc: linux-wireless@vger.kernel.org,
	"Chatre, Reinette" <reinette.chatre@intel.com>
In-Reply-To: <20080328023336.GA10006@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1ba2fa240803271823m4adecaeat9ad05ee6bb97969b@mail.gmail.com>
	 <20080328023336.GA10006@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 28, 2008 at 5:33 AM, John W. Linville
<linville@tuxdriver.com> wrote:
>
> On Fri, Mar 28, 2008 at 03:23:28AM +0200, Tomas Winkler wrote:
>  > John, what restraining you from applying TKIP patches to wireless-testing
>  > First of all they were acked by Johannes second they need to got into
>  > wider use, most of  the people don't pick up code from the mailing
>  > list but from git directory.
>  > Even TKIP is stupid encryption schema and everybody wants see it dead
>  > it's still used. From our testing our patches reduces significantly
>  > cpu utilization and throughput.
>  > If there are any other issues please let us know
>
>  The only TKIP-related patches I have in my queue that haven't been
>  applied are some cleanups from Harvey Harrison.  What other patches
>  do you mean?  The ones from a week or so ago have already been applied.

Hmm, have to missed it somehow, my mistake.  I've seen only the revert
patches before.
Thanks
Tomas
