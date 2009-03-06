Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:25788 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737AbZCFBer (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2009 20:34:47 -0500
Received: by wf-out-1314.google.com with SMTP id 28so249476wfa.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 17:34:45 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 5 Mar 2009 17:34:45 -0800
Message-ID: <43e72e890903051734p6e3bff7ey7d97764177daa6c8@mail.gmail.com> (sfid-20090306_023508_362044_76F22DD3)
Subject: crda on git
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If you were using crda from git please pull, fixed a stupid typo from
a previous patch where the rules file only had the SBINDIR but no
crda, whoops :).

  Luis
