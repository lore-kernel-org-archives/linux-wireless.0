Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:20875 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759670AbYF0UA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 16:00:56 -0400
Received: by wr-out-0506.google.com with SMTP id 69so530764wri.5
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 13:00:55 -0700 (PDT)
Message-ID: <43e72e890806271300m626f67ayabf43fa02fe239b8@mail.gmail.com> (sfid-20080627_220100_856328_D1EC308A)
Date: Fri, 27 Jun 2008 13:00:55 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: compat-wireless high packet loss.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"David Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	"Cohen, Guy" <guy.cohen@intel.com>
In-Reply-To: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1ba2fa240806261603g30c3e757y9166c2f9e05f7666@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 26, 2008 at 4:03 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> We've experienced very high packet loss when using latest
> compat-wireless witth iwlwifi driver over 2.6.24 and 2.6.25 stable
> kernels. This is not happening with 2.6.26-rc3 as a target kernel (not
> sure about rc1 and rc2)
> The traffic is UDP TX with large tx buffers ~26000.
> We are still investigating yet if someone has any idea please share with us.

I can't think of anything off the top of my head, really...

  Luis
