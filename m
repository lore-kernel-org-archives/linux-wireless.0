Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:8196 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbYIZHYw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 03:24:52 -0400
Received: by yx-out-2324.google.com with SMTP id 8so142671yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 00:24:51 -0700 (PDT)
Message-ID: <43e72e890809260024ob134358me80ae1c169e4da8e@mail.gmail.com> (sfid-20080926_092457_807913_1768D225)
Date: Fri, 26 Sep 2008 00:24:51 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Getting country alpha2 on network manager and using it for crda
Cc: linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So since this may not happen for a while I figure I can give a shot.
But I'm curious where we should get our country alpha2 from? Does LSB
define a country has to be somewhere? Maybe the locale? Timezone?
Anyway, in the end the user should be able to change the country too.

I'm thinking to start by just letting the user pick a country for now.
We can figure out where the hell it gets the country by default later
but if you have ideas that'd be great. It seems reasonable to ask for
this upon installation time (?)

  Luis
