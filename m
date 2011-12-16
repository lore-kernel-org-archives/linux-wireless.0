Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from klovia.htt-consult.com ([208.83.67.149]:57112 "EHLO
	klovia.htt-consult.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab1LPTou (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 14:44:50 -0500
Received: from localhost (unknown [127.0.0.1])
	by klovia.htt-consult.com (Postfix) with ESMTP id 1C90862A71
	for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 19:38:34 +0000 (UTC)
Received: from klovia.htt-consult.com ([127.0.0.1])
	by localhost (klovia.htt-consult.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jWdA9WiRiaUs for <linux-wireless@vger.kernel.org>;
	Fri, 16 Dec 2011 14:38:22 -0500 (EST)
Received: from lx120e.htt-consult.com (157.67.83.208.client.htt-consult.com [208.83.67.157])
	(Authenticated sender: rgm@htt-consult.com)
	by klovia.htt-consult.com (Postfix) with ESMTPSA id ABAEF62A6B
	for <linux-wireless@vger.kernel.org>; Fri, 16 Dec 2011 14:38:22 -0500 (EST)
Message-ID: <4EEB9E2E.9050004@htt-consult.com> (sfid-20111216_204453_117443_BFFC7427)
Date: Fri, 16 Dec 2011 14:38:22 -0500
From: Robert Moskowitz <rgm@htt-consult.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: SAE support
References: <S1760568Ab1LPTWy/20111216192254Z+423@vger.kernel.org>
In-Reply-To: <S1760568Ab1LPTWy/20111216192254Z+423@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see in:

http://marc.info/?l=linux-wireless&m=130145440930760&w=2

That SAE support is in for mesh networking.  SAE is so defined that it 
can be used for STA authentication to an AP or in AdHoc mode.  It is NOT 
limited to mesh node authentication.  This was extensively discussed at 
the 802.11 meetings as a reason that specific support of SAE by STAs did 
not need to be defined; it was already in there.

so......

if an AP is advertising SAE in an IE in the BEACON, what will it take 
for the STA to respond?  Does this patch provide the necessary 
functionality?  See sec 8.2a in IEEE 802.11s-2011.

Thank you.


