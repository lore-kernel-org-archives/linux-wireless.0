Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:41510 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137AbYGQKQI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 06:16:08 -0400
Received: by an-out-0708.google.com with SMTP id d40so147074and.103
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2008 03:16:07 -0700 (PDT)
Message-ID: <43e72e890807170316xcd6528cpcef4a8f669a22d08@mail.gmail.com> (sfid-20080717_121613_762839_0CA97E25)
Date: Thu, 17 Jul 2008 03:16:07 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: 2nd REVISED AGENDA -- Re: Linux Wireless Mini-Summit -- Ottawa -- July 22, 2008
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <20080716184803.GB3232@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080709190915.GA8238@tuxdriver.com>
	 <20080715182654.GA5969@tuxdriver.com>
	 <20080716184803.GB3232@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 16, 2008 at 11:48 AM, John W. Linville
<linville@tuxdriver.com> wrote:

> I'm still looking for more/different topics

A couple I can think of:

* Compat-wireless, this can be discussed after new MQ patch. We may
have to freeze mac80211 for old kernels for compat-wireless after the
MQ patch goes through and only leave in it fixes moving forward. This
consideration is because porting the MQ patch may be very difficult to
maintain. It was expected though that the first MQ patch could not be
ported though so we'll see, we just might be able to port this
properly. We can talk about this further at the summit.

* Testing -- lets get serious about automation of testing. The Orbit
grid is still available, we just need to put together scripts and test
scenarios.

* Rate control cleanup -- this needs to a good review and cleanup.
Probably not high on our priority list though. We can talk about this
further during the "rate scaling algs" section on the agenda.

  Luis
