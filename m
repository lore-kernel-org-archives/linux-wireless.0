Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.polito.it ([130.192.182.65]:58348 "EHLO mx.polito.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760682Ab2CPJ2n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 05:28:43 -0400
Received: from polito.it (atena.polito.it [130.192.3.45])
	by fm1nodo5.polito.it  with ESMTP id q2G91KTw024753-q2G91KTx024753
	for <linux-wireless@vger.kernel.org>; Fri, 16 Mar 2012 10:01:20 +0100
Received: from [130.192.86.1] (HELO [192.168.85.111])
  by atena.polito.it (CommuniGate Pro SMTP 5.4.3)
  with ESMTPS id 52502318 for linux-wireless@vger.kernel.org; Fri, 16 Mar 2012 10:01:20 +0100
Message-ID: <1331888479.13561.22.camel@MacGyver> (sfid-20120316_102847_230657_EE87E801)
Subject: ath9k state machine ?
From: Guido Gavilanes <gavilanes@ismb.it>
Reply-To: gavilanes@ismb.it
To: linux-wireless@vger.kernel.org
Date: Fri, 16 Mar 2012 10:01:19 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello linux-wireless colleagues,

Let me disturb you with a non-deep-in-the-code question...
I am working on an specific application starting from ath9k driver.
Basically I have to capture acks being used as triggers for other
actions at user level, so it would be useful to know the "journey of a
packet" through the driver (ath9k). Is this information available to
you? (publicly available?) I have searched for a while without results;
at the moment I am "blindly" working with a code analyzer through the
driver source with little and slow results, but A description of the
"state machine" would be more than useful; do you now where can I get
something?

Thank you in advance for your help
Guido



