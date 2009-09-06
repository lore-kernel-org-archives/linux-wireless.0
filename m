Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:16001 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693AbZIFOn0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Sep 2009 10:43:26 -0400
Received: by ey-out-2122.google.com with SMTP id 25so802238eya.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2009 07:43:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909051252n33b36b61n4dc3484a73851610@mail.gmail.com>
References: <43e72e890909051252n33b36b61n4dc3484a73851610@mail.gmail.com>
Date: Sun, 6 Sep 2009 16:43:28 +0200
Message-ID: <2d0a357f0909060743t37d9aba2k5fe79baf34581396@mail.gmail.com>
Subject: Re: compat-wireless fixed
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Riccardo Gori <goric@trivenet.it>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just as a feedback:
Building compat-wireless (2009-09-06) against 2.6.31-rc9 fails with
the same error-message as yesterday.
Fixed as described on [1]

-SD

[1] http://marc.info/?l=linux-wireless&m=125214811222548&w=2

On Sat, Sep 5, 2009 at 9:52 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> Haven't tried building it myself but I think it should be fixed now.
>
> git-describe for wireless-testing.git says: v2.6.31-rc8-34797-g4910edb
> This is a bleeding edge compat-wireless release based on: master-2009-09-04
> This is compat-release: master-2009-09-04
>
>  Luis
>
