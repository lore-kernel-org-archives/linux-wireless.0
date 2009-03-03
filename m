Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:19132 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZCCFn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2009 00:43:28 -0500
MIME-Version: 1.0
Date: Mon, 2 Mar 2009 21:43:26 -0800
Message-ID: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com> (sfid-20090303_064332_051073_45C71AAE)
Subject: Elaboration on "Equivalent fix must already exist in Linus' tree"
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While extending the documentation for submitting Linux wireless bug
reports [1] we note the stable series policy on patches -- that of
having an equivalent fix already in Linus' tree. I find this
documented in Documentation/stable_kernel_rules.txt but I'm curious if
there is any other resource which documents this or elaborates on this
a bit more. I often tell people about this rule or push _really_ hard
on testing "upstream" but some people tend to not understand. I think
that elaborating a little on this can help and will hopefully create
more awareness around the importance of trees like Stephen's
linux-next tree.

[1] http://wireless.kernel.org/en/users/Documentation/Reporting_bugs
[2] git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git

  Luis
